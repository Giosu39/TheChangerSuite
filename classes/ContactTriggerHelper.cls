public with sharing class ContactTriggerHelper {
  public static void validateOwnership(
    List<Contact> triggerOld,
    List<Contact> triggerNew
  ) {
    List<Contact> cons = [
      SELECT ownerid, account.ownerid
      FROM contact
      WHERE id IN :triggerNew
    ];
    for (integer i = 0; i < triggerOld.size(); i++) {
      for (contact c : cons) {
        if (triggerOld[i].id == c.id) {
          if (triggerNew[i].ownerid != c.account.OwnerId) {
            triggerNew[i].addError('L\'owner di account è diverso');
          }
        }
      }
    }
  }
}
