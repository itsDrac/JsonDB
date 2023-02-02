@tool
class_name JSONDB extends EditorPlugin
@icon("res://addons/jsondb/JSONDB.svg")

signal _db_detail_changed

var file: FileAccess
var _dbData: Dictionary
var databaseName: StringName = "base.json" :
	get :
		return databaseName
	set(val):
		if val.is_valid_filename():
			if val.ends_with(".json"):
				databaseName = val
			else:
				databaseName += ".json"
		elif val.is_empty():
			databaseName = "base.json"
		emit_signal("_db_detail_changed")

var databasePath: StringName = "res://Database/" :
	get :
		return databasePath
	set(val):
		if val.is_empty():
			databasePath = "res://Database/"
		if val.is_absolute_path(): 
			databasePath = val.simplify_path()
		emit_signal("_db_detail_changed")

# Basic Functions

func _extract_data(file: FileAccess):
	var strData = file.get_as_text()
	var jsonData = JSON.parse_string(strData)
	if jsonData :
		_dbData = jsonData
		return jsonData
	_dbData = {}

func add_keys(keyList: Array) :
	for key in keyList:
		if ! _dbData.has(key):
			_dbData[key] = []

func with_file(fun: Callable):
	if ! FileAccess.file_exists(databasePath+databaseName):
		file = FileAccess.open(databasePath+databaseName,2)
	else :
		file = FileAccess.open(databasePath+databaseName,3)
	
	fun.call(file)
	file = null

func _db_details_update():
	with_file(_extract_data)

func _init(dbName: StringName, dbPath: StringName):
	connect("_db_detail_changed", _db_details_update)
	
	if !dbName.is_empty():
		databaseName = dbName
	if !dbPath.is_empty():
		databasePath = dbPath
		
	if !databaseName.is_empty() and !databasePath.is_empty():
		emit_signal("_db_detail_changed")

# CRUD Functions

func insert_one(key: StringName, data: Dictionary):
	if _dbData.has(key):
		data["_id"] = str(_dbData[key].size()+1).sha1_text()
		_dbData[key].append(data)

func get_data(key=null):
	if _dbData.is_empty():
		return null
	
	if key:
		if _dbData.has(key):
			return _dbData[key]
		return {}
	
	return _dbData

func update_one(key: StringName, originalData: Dictionary, newData: Dictionary):
	if _dbData.has(key):
		var allData = get_data(key)
		var oldData = allData.filter(func(d): return d if d["_id"] == originalData["_id"] else null)
		if oldData:
			newData["_id"] = oldData[0]["_id"]
			allData.erase(oldData)
			allData.append(newData)
		
		_dbData[key] = allData

func delete_one(key:StringName, data: Dictionary):
	if _dbData.has(key):
		var allData = get_data(key)
		allData.erase(data)
		_dbData[key] = allData

func commit():
	var str_data = JSON.stringify(_dbData, "\t")
	with_file(func(file): file.store_string(str_data))

func _enter_tree():
	# Initialization of the plugin goes here.
	pass


func _exit_tree():
	# Clean-up of the plugin goes here.
	pass
