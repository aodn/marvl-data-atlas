databaseChangeLog() {
    changeSet(author: 'jkburges', id: '1424644927-01') {

        // Example migration to subset the full production data.
        // delete(tableName: 'measurements') {
        //     where("ST_Disjoint(geom, 'POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))'::geography::geometry)")
        // }
    }
}
