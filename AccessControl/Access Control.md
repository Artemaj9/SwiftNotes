# Access Control

## internal
####Usable by any onject in my app or framework (this is the default)
## private 
#### Onl callable from within object
## private(set)
#### this property is readable outside this object, but not settable
## fileprivate
#### accessible by any code in this source file
## public
#### (for frameworks only) this can be used by objects outside my framework
## open 
#### (for frameworks only) public and object outside my framework can subclass this, override methods...


A good strategy is to just mark everything private by default. Then remove the private designation when the API is ready to be used by other code.
 
