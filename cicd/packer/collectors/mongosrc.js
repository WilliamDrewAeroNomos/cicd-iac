use dashboarddb
db.createUser(
    {
        user: "dashboarduser",
        pwd: "dbpassword",
        roles: [
            {role: "readWrite", db: "dashboard"}
        ]
    })
db.dummmyCollection.insert({x: 1});
