# Port to Ruby/RubyCocoa of the Low-level CoreData Tutorial
# from Apple.
# Apple Inc. © 2005, 2006 Apple Computer, Inc.
#
# The RUbyCocoa version is released under the MIT License

require 'osx/cocoa'
OSX.require_framework 'CoreData'

module CoreDataCLI

  #-- constants
  STORE_TYPE = OSX::NSXMLStoreType
  STORE_FILENAME = "CDCLI.xml"

  #-- module variables
  @@mom = nil
  @@moc = nil

  #-- functions
  def self.managedObjectModel

    if @@mom
      return @@mom
    end

    @@mom = OSX::NSManagedObjectModel.alloc.init
    runEntity = OSX::NSEntityDescription.alloc.init
    runEntity.setName('Run')
    runEntity.setManagedObjectClassName('Run')
    @@mom.setEntities(OSX::NSArray.arrayWithObject(runEntity))

    #-- date attribute
    dateAttribute = OSX::NSAttributeDescription.alloc.init
    dateAttribute.setName('date')
    dateAttribute.setAttributeType(OSX::NSDateAttributeType)
    dateAttribute.setOptional(false)

    #-- processID attribute
    idAttribute = OSX::NSAttributeDescription.alloc.init
    idAttribute.setName('processID')
    idAttribute.setAttributeType(OSX::NSInteger32AttributeType)
    idAttribute.setOptional(false)
    idAttribute.setDefaultValue(OSX::NSNumber.numberWithInt(-1))

    #-- Validation Predicate and Warning
    lhs = OSX::NSExpression.expressionForEvaluatedObject
    rhs = OSX::NSExpression.expressionForConstantValue(OSX::NSNumber.numberWithInt(0))
    validationPredicate = OSX::NSComparisonPredicate.objc_send(
          :predicateWithLeftExpression, lhs,
          :rightExpression, rhs,
          :modifier, OSX::NSDirectPredicateModifier,
          :type, OSX::NSGreaterThanOrEqualToComparison,
            ptions, nil)

    validationWarning = OSX::NSLocalizedString("Process ID must not be less than 0.",
          "Process ID must not be less than 0.")

    idAttribute.objc_send(
          :setValidationPredicates, OSX::NSArray.arrayWithObject(validationPredicate),
          :withValidationWarnings, OSX::NSArray.arrayWithObject(validationWarning))

    runEntity.setProperties(OSX::NSArray.arrayWithObjects(dateAttribute, idAttribute, nil))

    return @@mom
  end

  LOG_DIR = "CDCLI"
  def self.applicationLogDirectory
    ald = nil
    if (ald != nil)
      return ald
    end

    paths = OSX::NSSearchPathForDirectoriesInDomains(
          OSX::NSLibraryDirectory,
          OSX::NSUserDomainMask,
          true)

    if (paths.count == 1)
      ald = paths.to_a[0].to_s + "/Logs/" + LOG_DIR
      fileManager = OSX::NSFileManager.defaultManager
      isDirectory = "NO"
      if fileManager.fileExistsAtPath_isDirectory(ald, isDirectory)
        return ald
      end
      if fileManager.createDirectoryAtPath(ald, :attributes, nil)
        return ald
      end
      ald = nil
    end
  end

  def self.managedObjectContext

    if (@@moc)
      return @@moc
    end

    @@moc = OSX::NSManagedObjectContext.alloc.init

    coordinator = OSX::NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(managedObjectModel)

    log_file = applicationLogDirectory() + "/" + STORE_FILENAME
    url = OSX::NSURL.fileURLWithPath(log_file)
    print "url=", url, "\n"

# newStore, error = coordinator.addPersistentStoreWithType_configuration_URL_options_error(STORE_TYPE, nil, url, nil, nil)

    newStore, error = coordinator.objc_send(:addPersistentStoreWithType, STORE_TYPE,
          :configuration, nil,
          :URL, url,
            ptions, nil,
          :error, error)

    if (newStore == nil)
      OSX::NSLog("Store configuration Failure\n%@", error.localizedDescription)
    end

    @@moc.setPersistentStoreCoordinator(coordinator)
    @@moc
  end

  class Run 1000) AND (processID < 8580)")
request.setPredicate(predicate)

result, err = moc.executeFetchRequest_error(request, err)

 if (result == 0 || err)
   OSX::NSLog("Error while fetching\n%@", err.localizedDescription)
   exit -3
 end

enumerator = result.objectEnumerator
while (run = enumerator.nextObject) != nil
  if (run)
    print "On ", run.date, " as process ID ", run.processID, "\n"
  end
end