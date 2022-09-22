public with sharing class AccountTriggerHelper {
  public static void changeOwnerOnChildren(
    List<Account> triggerOld,
    List<Account> triggerNew
  ) {
    List<Contact> cons = [
      SELECT id, ownerId, AccountId
      FROM contact
      WHERE AccountId IN :triggerNew
    ];

    List<Opportunity> opps = [
      SELECT id, ownerId, AccountId
      FROM opportunity
      WHERE AccountId IN :triggerNew
    ];

    for (integer i = 0; i < triggerNew.size(); i++) {
      if (triggerOld[i].ownerId != triggerNew[i].ownerId) {
        // Se entriamo nell'if, vuol dire che sta avvenendo un cambio owner
        for (Contact c : cons) {
          if (c.AccountId == triggerNew[i].id) {
            c.OwnerId = triggerNew[i].OwnerId;
          }
        }
        for (Opportunity o : opps) {
          if (o.AccountId == triggerNew[i].id) {
            o.OwnerId = triggerNew[i].OwnerId;
          }
        }
      }
    }

    upsert cons;
    upsert opps;
  }
}
