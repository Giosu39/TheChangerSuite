public with sharing class OpportunityTriggerHelper {
  public static void validateOwnership(
    List<Opportunity> triggerOld,
    List<Opportunity> triggerNew
  ) {
    List<Opportunity> op = [
      SELECT ownerid, account.ownerid
      FROM opportunity
      WHERE id IN :triggerNew
    ];
    for (integer i = 0; i < triggerNew.size(); i++) {
      for (Opportunity o : op) {
        if (triggerNew[i].id == o.id) {
          if (triggerNew[i].ownerid != o.account.OwnerId) {
            triggerNew[i].addError('L\'owner di account è diverso');
          }
        }
      }
    }
  }
}
