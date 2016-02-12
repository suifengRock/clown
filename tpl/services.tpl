package {{.pkgName}}

{{if .importPkg}}
import (
	{{range .importPkg}}
		{{.path}}
	{{end}}
)
{{end}}


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
		log.Error("has no id[%d]", id)
		return nil, errors.New("has no id")
	}
	return
}
