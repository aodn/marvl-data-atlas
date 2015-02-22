databaseChangeLog() {
    changeSet(author: 'jkburges', id: '1424408327-01') {
        createView(viewName: 'my_new_view') {
            'select * from measurements'
        }
    }
}
