package service

import (
	m "common/models"
)



{{range .struct.Fields}}
func (svc *Svc) Get{{$.struct.Name}}By{{.Name}} ({{.TransName}} {{.Type}}) (*m.{{$.struct.Name}}, error){
	return svc.getDao().Get{{$.struct.Name}}By{{.Name}}({{.TransName}})
}

func (svc *Svc) Get{{$.struct.Name}}UnscopedBy{{.Name}} ({{.TransName}} {{.Type}}) (*m.{{$.struct.Name}}, error){
	return svc.getDao().Get{{$.struct.Name}}UnscopedBy{{.Name}}({{.TransName}})
}

{{if .Type|eq "int"}} 
func (svc *Svc) Search{{$.struct.Name}}By{{.Name}}s ({{.TransName}}_in []int) ([]*m.{{$.struct.Name}}, error){
	return svc.getDao().Search{{$.struct.Name}}By{{.Name}}s ({{.TransName}}_in)
}

func (svc *Svc) Search{{$.struct.Name}}PageBy{{.Name}}s ({{.TransName}}_in []int,page int, pageSize int) ([]*m.{{$.struct.Name}}, error){
	return svc.getDao().Search{{$.struct.Name}}PageBy{{.Name}}s ({{.TransName}}_in,page,pageSize)
}

func (svc *Svc) Search{{$.struct.Name}}UnscopedBy{{.Name}}s ({{.TransName}}_in []int) ([]*m.{{$.struct.Name}}, error){
	return svc.getDao().Search{{$.struct.Name}}UnscopedBy{{.Name}}s ({{.TransName}}_in)
}
{{end}}{{end}}


func (svc *Svc) Create{{.struct.Name}} ({{range .struct.Fields}}{{ if .Name|eq "Id"}}{{else}}{{.TransName}} {{.Type}},{{end}}{{end}}
)(item *m.{{$.struct.Name}}, err error){
	return svc.getDao().Create{{.struct.Name}} ({{range .struct.Fields}}{{ if .Name|eq "Id"}}{{else}}{{.TransName}} ,{{end}}{{end}})
}

func (svc *Svc) Insert{{.struct.Name}}s(items []*m.{{.struct.Name}}) error {
	return svc.getDao().Insert{{.struct.Name}}s(items)
}

func (svc *Svc) Delete{{.struct.Name}}(id int) (err error) {
	return svc.getDao().Delete{{.struct.Name}}(id)
}

//=======================================================================================================================


