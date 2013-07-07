module Orientdb4r

  # Version history.
  VERSION_HISTORY = [
    ['0.3.4',   '2013-02-16', "Enh #17 (database import/export)"],
    ['0.3.3',   '2012-12-16', "Enh #18 ('abstract' option into creating a new class), Enh #19 (GET - List Databases)"],
    ['0.3.2',   '2012-11-02', "Enh #13 (User-Agent), Enh #16 (configurable Recover Time in Load Balancing)"],
    ['0.3.1',   '2012-08-27', "Timeout for reuse of dirty nodes in load balancing; BF #14, BF #15"],
    ['0.3.0',   '2012-08-01', "Added support for cluster of distributed servers + load balancing"],
    ['0.2.10',  '2012-07-21', "Experimental support for Excon HTTP library with Keep-Alive connection"],
    ['0.2.9',   '2012-07-18', "Added feature Client#delete_database, New class Rid"],
    ['0.2.8',   '2012-07-16', "New exception handling, added feature Client#create_class(:properties)"],
    ['0.2.7',   '2012-07-07', "Added method Client#class_exists?"],
    ['0.2.6',   '2012-07-03', "BF #8, BF #6"],
    ['0.2.5',   '2012-07-01', "Added 'get_database' into database CRUD"],
    # v-- https://groups.google.com/forum/?fromgroups#!topic/orient-database/5MAMCvFavTc
    ['0.2.4',   '2012-06-26', "Added session management"],
    ['0.2.3',   '2012-06-24', "Documents received by a query are kind of Orientdb4r::DocumentMetadata"],
    # v-- https://groups.google.com/forum/?fromgroups#!topic/orient-database/jK4EZd068AE
    # v-- https://groups.google.com/forum/?fromgroups#!topic/orient-database/nJOAsgwSnKI
    ['0.2.2',   '2012-06-23', "Added support for server version detection [r5913]"],
    ['0.2.1',   '2012-06-19', "Fixed linked property definition"],
    ['0.2.0',   '2012-06-12', "Introduces document's CRUD operations"],
    ['0.1.2',   '2012-06-10', 'Introduces new OClass module'],
    ['0.1.1',   '2012-06-08', 'First working version (including unit tests) released at github.com'],
    ['0.1.0',   '2012-06-02', 'Initial version on Ruby-1.9.3p194 and OrientDB-1.0.0']
  ]

  # Current version.
  VERSION = VERSION_HISTORY[0][0]

end
