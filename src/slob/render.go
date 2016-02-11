package slob

import "text/template"

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

func (r *render) Execute(structName string) {
	tmpl, err := template.ParseGlob(r.TmplPath)
	if err != nil {
		panic(err)
	}
	fd, err := GenFileHandle(structName)
	defer fd.Close()
	if err != nil {
		panic(err)
	}
	err = tmpl.Execute(fd, r.Data)
	if err != nil {
		panic(err)
	}
}
