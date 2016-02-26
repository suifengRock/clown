package dao

import (
	"github.com/go-xorm/xorm"

	m "bizcore/zj2/models"
	// "common/consts"
	"common/log"
	"common/utils"
)

type searchADCFFilter struct {
	utils.BaseFilter
	AAA    string
	BBB    string
	CCC    int
	CCC_In []int

	UpdateTime int
	Unscoped   bool
}

type searchADCFPagerFilter struct {
	searchProjCheckTaskFilter
	Page     int
	PageSize int
}

func (f searchADCFFilter) CheckUnscoped(tx *xorm.Session) *xorm.Session {
	if f.Unscoped {
		tx.Unscoped()
	}
	return tx
}

func (f searchADCFFilter) GetQuery(tx *xorm.Session) *xorm.Session {
	f.CheckUnscoped(tx)

	if f.HasField("AAA") && len(f.AAA) > 0 {
		name := fmt.Sprintf("%%%s%%", f.AAA)
		tx.And("a_a_a like ?", f.AAA)
	}

	if f.HasField("BBB") && len(f.BBB) > 0 {
		name := fmt.Sprintf("%%%s%%", f.BBB)
		tx.And("b_b_b like ?", f.BBB)
	}

	if f.HasField("CCC") {
		tx.And("c_c_c = ?", f.CCC)
	}
	if f.HasField("CCC_In") && len(f.CCC) > 0 {
		tx.In("c_c_c", f.CCC_In)
	}

	if f.HasField("UpdateTime") && f.UpdateTime > 0 {
		tx.And("update_at > ?", utils.UnixtimeToDate(f.UpdateTime, ""))
	}
	return tx
}

func (f *searchADCFPagerFilter) GetPageQuery(tx *xorm.Session) *xorm.Session {
	tx = f.GetQuery(tx)

	offset := (f.Page - 1) * f.PageSize
	tx.Limit(f.PageSize, offset)
	return tx
}

func (dao *Dao) searchADCF(f *searchADCFFilter) (items []*m.ADCF, err error) {
	items = make([]*m.ADCF, 0)
	if err = f.GetQuery(dao.getDb()).Find(&items); err != nil {
		log.Error(err.Error())
	}
	return
}

func (dao *Dao) getADCF(f *searchADCFFilter) (*m.ADCF, error) {
	item := new(m.ADCF)
	has, err := f.GetQuery(dao.getDb()).Get(item)
	if err != nil {
		log.Error(err.Error())
		return nil, err
	}
	if !has {
		return nil, nil
	}
	return item, nil
}

func (dao *Dao) searchADCFPager(f *searchADCFPagerFilter) (items []*m.ADCF, err error) {
	items = make([]*m.ADCF, 0)
	if err = f.GetPageQuery(dao.getDb()).Find(&items); err != nil {
		log.Error(err.Error())
	}
	return
}

//==================================================================

func (dao *Dao) GetADCFByAAA(a_a_a string) (*m.ADCF, error) {
	f := searchADCFFilter{AAA: a_a_a}
	f.Fields("AAA")
	return dao.getADCF(f)
}

func (dao *Dao) GetADCFUnscopedByAAA(a_a_a string) (*m.ADCF, error) {
	f := searchADCFFilter{Unscoped: true, AAA: a_a_a}
	f.Fields("AAA", "Unscoped")
	return dao.getADCF(f)
}

func (dao *Dao) GetADCFByBBB(b_b_b string) (*m.ADCF, error) {
	f := searchADCFFilter{BBB: b_b_b}
	f.Fields("BBB")
	return dao.getADCF(f)
}

func (dao *Dao) GetADCFUnscopedByBBB(b_b_b string) (*m.ADCF, error) {
	f := searchADCFFilter{Unscoped: true, BBB: b_b_b}
	f.Fields("BBB", "Unscoped")
	return dao.getADCF(f)
}

func (dao *Dao) GetADCFByCCC(c_c_c int) (*m.ADCF, error) {
	f := searchADCFFilter{CCC: c_c_c}
	f.Fields("CCC")
	return dao.getADCF(f)
}

func (dao *Dao) GetADCFUnscopedByCCC(c_c_c int) (*m.ADCF, error) {
	f := searchADCFFilter{Unscoped: true, CCC: c_c_c}
	f.Fields("CCC", "Unscoped")
	return dao.getADCF(f)
}

func (dao *Dao) SearchADCFByCCCs(c_c_c_in []int) ([]*m.ADCF, error) {
	f := searchADCFFilter{CCC_In: c_c_c_in}
	f.Fields("CCC_In")
	return dao.searchADCF(f)
}

func (dao *Dao) SearchADCFPageByCCCs(c_c_c_in []int, page int, pageSize int) ([]*m.ADCF, error) {
	f := searchADCFFilter{CCC_In: c_c_c_in, Page: page, PageSize: pageSize}
	f.Fields("CCC_In")
	return dao.searchADCFPage(f)
}

func (dao *Dao) SearchADCFUnscopedByCCCs(c_c_cs []int) ([]*m.ADCF, error) {
	f := searchADCFFilter{Unscoped: true, CCC: c_c_c}
	f.Fields("CCC", "Unscoped")
	return dao.searchADCF(f)
}

//==================================================================

func (dao *Dao) CreateADCF(a_a_a string, b_b_b string, c_c_c int,
) (item *m.ADCF, err error) {
	item = new(m.ADCF)

	item.AAA = a_a_a
	item.BBB = b_b_b
	item.CCC = c_c_c

	if err = dao.insert(item); err != nil {
		log.Error(err.Error())
	}
	return
}

func (dao *Dao) InsertADCFs(items []*m.ADCF) error {
	return dao.insert(items)
}

func (dao *Dao) DeleteADCF(id int) (err error) {
	if err = dao.deleteByIds(new(m.ADCF), id); err != nil {
		log.Error(err.Error())
	}
	return
}
