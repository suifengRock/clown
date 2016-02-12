package slob

import "reflect"

type input interface {
	Read(...interface{})
	Render(*render)
}

type StructInput struct {
	structSet []*Struct
}

type Struct struct {
	Name   string
	Fields []*Field
}

type Field struct {
	Name string
	Type string
}

func (i *StructInput) Read(model ...interface{}) {
	i.structSet = make([]*Struct, 0)
	for _, obj := range model {
		st := new(Struct)
		typ := reflect.TypeOf(obj).Elem()
		st.Name = typ.Name()
		tmp := typ.NumField()
		fields := make([]*Field, 0)
		for i := 0; i < tmp; i++ {
			field := typ.Field(i)
			fld := new(Field)
			fld.Name = field.Name
			fld.Type = field.Type.Name()
			fields = append(fields, fld)
		}
		st.Fields = fields
		i.structSet = append(i.structSet, st)
	}

}

func (i *StructInput) Render(r *render) {
	for _, obj := range i.structSet {
		r.SetFileName(obj.Name).Set("struct", obj).execute()
	}
}

var slob_input input = new(StructInput)

func SetInput(inp input) {
	slob_input = inp
}
