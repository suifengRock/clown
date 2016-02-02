package main

import (
	"fmt"
	"reflect"
	"slob"
)

type Struct struct {
	Name   string
	Fields []*Field
}

type Field struct {
	Name string
	Type string
}

type ADCF struct {
	AAA string
	BBB string
	CCC int
}

func main() {
	obj := new(ADCF)
	stu := new(Struct)
	typ := reflect.TypeOf(obj).Elem()
	stu.Name = typ.Name()
	tmp := typ.NumField()
	fields := make([]*Field, 0)
	for i := 0; i < tmp; i++ {
		field := typ.Field(i)
		fld := new(Field)
		fld.Name = field.Name
		fld.Type = field.Type.Name()
		fields = append(fields, fld)
	}
	stu.Fields = fields
	fmt.Println("%s", stu.Name)
	for _, field := range stu.Fields {
		fmt.Println("%s:%s", field.Name, field.Type)
	}

	slob.Render("tpl/services.tpl").Set("pkgName", "testPkg").
		Set("struct", stu).
		Execute()

}

// package main

// import (
// 	"fmt"
// 	"slob"
// )

// type Latlng struct {
// 	Lat float32
// 	Lng float32
// }

// func (latlng Latlng) String() string {
// 	return fmt.Sprintf("%g/%g", latlng.Lat, latlng.Lng)
// }

// func main() {
// 	data := make([]map[string]interface{}, 0)
// 	data = append(data, map[string]interface{}{"name": "dotcoo1", "url": "http://www.dotcoo.com/", "latlng": Latlng{24.1, 135.1}})
// 	data = append(data, map[string]interface{}{"name": "dotcoo2", "url": "http://www.dotcoo.com/", "latlng": Latlng{24.2, 135.2}})
// 	data = append(data, map[string]interface{}{"name": "dotcoo2", "url": "http://www.dotcoo.com/", "latlng": Latlng{24.3, 135.3}})

// 	slob.Render("tpl/test.tpl").Set("data", data).Execute()
// }
