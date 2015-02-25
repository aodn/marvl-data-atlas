databaseChangeLog() {
    changeSet(author: 'jkburges', id: '1424408327-01') {
        createView(schemaName: 'aodn_dsto', viewName: 'my_new_view') {
            'select * from aodn_dsto.measurements'
        }
    }
}
