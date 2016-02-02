package slob

import (
	"os"
	"text/template"
)

type render struct {
	TmplPath string
	Data     template.FuncMap
}

func Render(tplPath string) *render {
	r := new(render)
	r.TmplPath = tplPath
	r.Data = template.FuncMap{}
	return r
}

func (r *render) Set(name string, param interface{}) *render {
	r.Data[name] = param
	return r
}

func (r *render) Execute() {
	tmpl, err := template.ParseGlob(r.TmplPath)
	if err != nil {
		panic(err)
	}
	err = tmpl.Execute(os.Stdout, r.Data)
	if err != nil {
		panic(err)
	}
}
