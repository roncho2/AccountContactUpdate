trigger updateChildPhone on Account (after  update) {

    Map<Id,Account> accMap = new Map<Id, Account>();
    if(trigger.isAfter && trigger.isUpdate ){
        if(!trigger.new.isEmpty()){
            for(Account accObj : trigger.new){
                if(accObj.Phone != trigger.oldMap.get(accObj.Id).Phone){
                    accMap.put(accObj.Id,accObj);

                }

            }

        }

    }
    if(!accMap.isEmpty()){
        List<Contact> conList =
         [SELECT Id, Phone, AccountId FROM Contact WHERE AccountId IN : accMap.keySet()];
        List<Contact> listToUpdateContacts = new List<Contact>();

        if(!conList.isEmpty()){
            for(Contact conObj : conList){

                conObj.Phone = accMap.get(conObj.AccountId).Phone;
                listToUpdateContacts.add(conObj);


            }

        }
        if(!listToUpdateContacts.isEmpty()){
            try{

        update listToUpdateContacts;
        
        }
        catch(exception ex){

        
        System.System.debug('Error while updating record -->' + ex.getMessage());
  
    }
  }

  }
}