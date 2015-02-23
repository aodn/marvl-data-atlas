databaseChangeLog() {

    include(file: 'aodn_dsto_initial_subset_changelog.groovy', relativeToChangelogFile: true)

    changeSet(author: 'jkburges', id: '1424408327-01') {
        createView(viewName: 'my_new_view') {
            'select * from measurements'
        }
    }
}
