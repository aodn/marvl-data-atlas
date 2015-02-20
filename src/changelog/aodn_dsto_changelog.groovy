databaseChangeLog() {
    changeSet(author: 'jkburges', id: '1424408327') {
        createView(viewName: 'my_new_view') {
            'select * from measurements'
        }
    }
}
