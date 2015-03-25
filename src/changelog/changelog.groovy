databaseChangeLog() {
    include(file: 'initial_subset_changelog.groovy', relativeToChangelogFile: true)
    include(file: 'aodn_dsto_changelog.groovy', relativeToChangelogFile: true)
}
