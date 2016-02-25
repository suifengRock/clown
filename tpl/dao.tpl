package dao

import (
	"github.com/go-xorm/xorm"

	m "bizcore/zj2/models"
	// "common/consts"
	"common/log"
	"common/utils"
)

type search{{.struct.Name}}Filter struct {
	utils.BaseFilter
	{{range .struct.Fields}} {{.Name}}	{{.Type}}
		{{if .Type|eq "int"}} {{.Name}}_In    []int 
	{{end}} {{end}}

	UpdateTime int
	Unscoped bool
}

type search{{.struct.Name}}PagerFilter struct {
	searchProjCheckTaskFilter
	Page     int
	PageSize int
}

func (f search{{.struct.Name}}Filter) CheckUnscoped(tx *xorm.Session) *xorm.Session {
	if f.Unscoped{
		tx.Unscoped()
	}
	return tx
}

func (f search{{.struct.Name}}Filter) GetQuery(tx *xorm.Session) *xorm.Session {
	f.CheckUnscoped(tx)

	{{range .struct.Fields}}
		{{if .Type|eq "string"}}
			if f.HasField("{{.Name}}") && len(f.{{.Name}})>0 {
				name := fmt.Sprintf("%%%s%%", f.{{.Name}})
				tx.And("{{.TransName}} like ?", f.{{.Name}})
			}
		{{end}}
		{{if .Type|eq "int"}} 
			if f.HasField("{{.Name}}") {
				tx.And("{{.TransName}} = ?", f.{{.Name}})
			}
			if f.HasField("{{.Name}}_In") && len(f.{{.Name}})>0 {
				tx.In("{{.TransName}}", f.{{.Name}}_In)
			}
		{{end}}
	{{end}}

	if f.HasField("UpdateTime") && f.UpdateTime > 0 {
		tx.And("update_at > ?", utils.UnixtimeToDate(f.UpdateTime, ""))
	}
	return tx
}

func (f *search{{.struct.Name}}PagerFilter) GetPageQuery(tx *xorm.Session) *xorm.Session {
	tx = f.GetQuery(tx)

	offset := (f.Page - 1) * f.PageSize
	tx.Limit(f.PageSize, offset)
	return tx
}


func (dao *Dao) search{{.struct.Name}}(f *search{{.struct.Name}}Filter) (items []*m.{{.struct.Name}}, err error) {
	items = make([]*m.{{.struct.Name}}, 0)
	if err = f.GetQuery(dao.getDb()).Find(&items); err != nil {
		log.Error(err.Error())
	}
	return
}

func (dao *Dao) get{{.struct.Name}}(f *search{{.struct.Name}}Filter) (*m.{{.struct.Name}}, error){
	item := new(m.{{.struct.Name}})
	has, err:= f.GetQuery(dao.getDb()).Get(item)
	if err != nil {
		log.Error(err.Error())
		return nil, err
	}
	if !has{
		return nil,nil
	}
	return item,nil
}

func (dao *Dao) search{{.struct.Name}}Pager(f *search{{.struct.Name}}PagerFilter) (items []*m.{{.struct.Name}}, err error) {
	items = make([]*m.{{.struct.Name}}, 0)
	if err = f.GetPageQuery(dao.getDb()).Find(&items); err != nil {
		log.Error(err.Error())
	}
	return
}

//==================================================================

{{range .struct.Fields}}
func (dao *Dao) Get{{$.struct.Name}}By{{.Name}} ({{.TransName}} {{.Type}}) (*m.{{$.struct.Name}}, error){
	f :=search{{$.struct.Name}}Filter{ {{.Name}}:{{.TransName}} }
	f.Fields("{{.Name}}")
	return dao.get{{$.struct.Name}}(f)
}

func (dao *Dao) Get{{$.struct.Name}}UnscopedBy{{.Name}} ({{.TransName}} {{.Type}}) (*m.{{$.struct.Name}}, error){
	f :=search{{$.struct.Name}}Filter{Unscoped:true,{{.Name}}:{{.TransName}}}
	f.Fields("{{.Name}}", "Unscoped")
	return dao.get{{$.struct.Name}}(f)
}

{{if .Type|eq "int"}} 
func (dao *Dao) Search{{$.struct.Name}}By{{.Name}}s ({{.TransName}}_in []int) ([]*m.{{$.struct.Name}}, error){
	f :=search{{$.struct.Name}}Filter{ {{.Name}}_In:{{.TransName}}_in }
	f.Fields("{{.Name}}_In")
	return dao.search{{$.struct.Name}}(f)
}

func (dao *Dao) Search{{$.struct.Name}}PageBy{{.Name}}s ({{.TransName}}_in []int,page int, pageSize int) ([]*m.{{$.struct.Name}}, error){
	f :=search{{$.struct.Name}}Filter{ {{.Name}}_In:{{.TransName}}_in,Page:page,PageSize:pageSize}
	f.Fields("{{.Name}}_In")
	return dao.search{{$.struct.Name}}Page(f)
}

func (dao *Dao) Search{{$.struct.Name}}UnscopedBy{{.Name}}s ({{.TransName}}s []int) ([]*m.{{$.struct.Name}}, error){
	f :=search{{$.struct.Name}}Filter{Unscoped:true,{{.Name}}:{{.TransName}}}
	f.Fields("{{.Name}}", "Unscoped")
	return dao.search{{$.struct.Name}}(f)
}
{{end}}

{{end}}

//==================================================================

func (dao *Dao) Create{{.struct.Name}} ({{range .struct.Fields}}{{ if .Name|eq "Id"}}{{else}}{{.TransName}} {{.Type}},{{end}}{{end}}
)(item *m.{{$.struct.Name}}, err error){
	item = new(m.{{.struct.Name}})
	{{range .struct.Fields }}{{if .Name|eq "Id"}}{{else}}
		item.{{.Name}} = {{.TransName}}{{end}}{{end}}

	if err = dao.insert(item); err != nil {
		log.Error(err.Error())
	}
	return
}

func (dao *Dao) Insert{{.struct.Name}}s(items []*m.{{.struct.Name}}) error {
	return dao.insert(items)
}

func (dao *Dao) Delete{{.struct.Name}}(id int) (err error) {
	if err = dao.deleteByIds(new(m.{{.struct.Name}}), id); err != nil {
		log.Error(err.Error())
	}
	return
}

