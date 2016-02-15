package {{.pkgName}}

import (
	"common/db"
	"common/log"
	m "common/models"
	"common/utils"
	"fmt"
)


func Get{{.struct.Name}}ByIdNoFundErr(id int) (item *m.{{.struct.Name}}, err error) {
	if id < 1 {
		log.Error("the id [%d]", id)
		return nil, errors.New("the id err")
	}
	item = new(m.{{.struct.Name}})
	tx, err := db.SessionBeginQuery()
	defer db.SessionCloseQuery()
	if err != nil {
		log.Error("the query session begin err ")
		return nil, err
	}

	has, err := tx.Id(id).Get(item)
	if err != nil {
		log.Error("session get err")
		return nil, err
	}
	if !has {
		log.Error("has no id[%d]", id)
		return nil, errors.New("has no id")
	}
	return
}


func Get{{.struct.Name}}ById(id int) (item *m.{{.struct.Name}}, err error) {
	if id < 1 {
		log.Error("the id [%d]", id)
		return nil, errors.New("the id err")
	}
	item = new(m.{{.struct.Name}})
	tx, err := db.SessionBeginQuery()
	defer db.SessionCloseQuery()
	if err != nil {
		log.Error("the query session begin err ")
		return nil, err
	}

	has, err := tx.Id(id).Get(item)
	if err != nil {
		log.Error("session get err")
		return nil, err
	}
	if !has {
		return nil, nil
	}
	return
}

func Delete{{.struct.Name}}ById(id int) (err error) {
	if id < 1 {
		log.Error("the id [%d]", id)
		return nil, errors.New("the id err")
	}
	obj :=new({{.struct.Name}})
	return db.SessionDelete(id, obj)
}

type search{{.struct.Name}}Filter struct {
	_BaseFilter

	{{range .struct.Fields}} {{.Name}}	{{.Type}}
		{{if .Type|eq "int"}} {{.Name}}s    []int 
	{{end}} {{end}}

	UpdateTime int
}

func (f searchPrivCheckItemFilter) GetQuery(tx *xorm.Session) *xorm.Session {
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
			if f.HasField("{{.Name}}s") && len(f.{{.Name}})>0 {
				tx.In("{{.TransName}}", f.{{.Name}}s)
			}
		{{end}}
	{{end}}

	if f.HasField("UpdateTime") && f.UpdateTime > 0 {
		tx.And("update_at > ?", utils.UnixtimeToDate(f.UpdateTime, ""))
	}
	return tx
}

func search{{.struct.Name}} (filter *search{{.struct.Name}}Filter) (items []*m.{{.struct.Name}}, err error) {
	tx, err := db.SessionBeginQuery()
	defer db.SessionCloseQuery()
	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	items = make([]*m.{{.struct.Name}}, 0)
	if err = filter.GetQuery(tx).Find(&items); err != nil {
		log.Debug(err.Error())
		return
	}
	return
}