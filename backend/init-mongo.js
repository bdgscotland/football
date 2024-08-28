db = connect("localhost:27017/admin");

db.createUser({
    user: "development",
    pwd: "development",
    roles: [
        { role: "root", db: "admin" },
        { role: "readWrite", db: "matchdb" }
    ]
});

db = connect("localhost:27017/matchdb");

db.createCollection("dummy_collection");
