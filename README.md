# JSONDB
## An ORM for json database in gdscript
### Godot 4.0+ beta plugin

---

## Initialize db

```
var databaseName
var databasePath
var db = JSONDB.new(databaseName, databasePath)
```

## Add key in Database

```
const USER = "USER"
func _ready():
    db.add_keys([USER])
```

## CRUD operation

### Create

> Don't add `_id` as a key as this is primary key used my JSONDB and is automaticaly added.
```
var u = {"email":"em@gm.co","password":"123"}
db.insert_one(USER,u)
```

### Read

```
db.get_data(USER)
```

### Update

> For updateing a data you need to pass on the old and new data

```
var newU = {"email":"emm@gmm.com","password":"zyx"}
var oldU = get_data(USER)[0]
db.update_one(USER, oldU, newU)
```

### Delete

```
var delU = get_data(USER)[0]
db.delete_one(USER,delU)
```

After doing the **CRUD** operations please commit the changes to update the file

```
db.commit()
```


## Note

for any feature request please create an issue and prepend it with `Feature:`
for any suggestions/feedback please create an issue and prepend it with 'Feedback:`

