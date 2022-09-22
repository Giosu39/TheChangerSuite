public with sharing class ChangeOwnerController {
  @AuraEnabled(cacheable=true)
  public static List<User> getUser() {
    return [SELECT id, name FROM user WHERE usertype = 'Standard'];
  }

  @AuraEnabled(cacheable=true)
  public static List<Account> getAccounts(String ownerId) {
    List<Account> accs = [SELECT id FROM account WHERE ownerId = :ownerId];
    return accs;
  }
  @AuraEnabled(cacheable=true)
  public static List<Contact> getContacts(String ownerId) {
    List<Contact> cons = [SELECT id FROM contact WHERE ownerId = :ownerId];
    return cons;
  }
  @AuraEnabled(cacheable=true)
  public static List<Opportunity> getOpportunities(String ownerId) {
    List<Opportunity> opps = [
      SELECT id
      FROM opportunity
      WHERE ownerId = :ownerId
    ];
    return opps;
  }

  @AuraEnabled
  public static String changeOwner(String userId, String recordId) {
    Pattern MyPatternAccount = Pattern.compile('^001.+');
    Matcher MyMatcherAccount = MyPatternAccount.matcher(recordId);
    boolean isAccount = MyMatcherAccount.matches();

    Pattern MyPatternContact = Pattern.compile('^003.+');
    Matcher MyMatcherContact = MyPatternContact.matcher(recordId);
    boolean isContact = MyMatcherContact.matches();

    Pattern MyPatternOpportunity = Pattern.compile('^006.+');
    Matcher MyMatcherOpportunity = MyPatternOpportunity.matcher(recordId);
    boolean isOpportunity = MyMatcherOpportunity.matches();

    if (isAccount == true) {
      Account a = [
        SELECT id, ownerid
        FROM account
        WHERE id = :recordId
        LIMIT 1
      ];
      a.ownerId = userId;
      try {
        update a;
      } catch (DMLException e) {
        return 'Error';
      }
      return 'Success';
    } else if (isOpportunity == true) {
      Opportunity o = [
        SELECT id, ownerid
        FROM opportunity
        WHERE id = :recordId
        LIMIT 1
      ];
      o.ownerId = userId;
      try {
        update o;
      } catch (DMLException e) {
        return 'Error';
      }
      return 'Success';
    } else if (isContact == true) {
      Contact c = [
        SELECT id, ownerid
        FROM contact
        WHERE id = :recordId
        LIMIT 1
      ];
      c.ownerId = userId;
      try {
        update c;
      } catch (DMLException e) {
        return 'Error';
      }
      return 'Success';
    }
    return 'Success';
  }

  @AuraEnabled(cacheable=true)
  public static List<User> getUsersWithoutRecordOwner(String recordId) {
    /* Matcher per capire che tipo di oggetto è */
    Pattern MyPatternAccount = Pattern.compile('^001.+');
    Matcher MyMatcherAccount = MyPatternAccount.matcher(recordId);
    boolean isAccount = MyMatcherAccount.matches();

    Pattern MyPatternContact = Pattern.compile('^003.+');
    Matcher MyMatcherContact = MyPatternContact.matcher(recordId);
    boolean isContact = MyMatcherContact.matches();

    Pattern MyPatternOpportunity = Pattern.compile('^006.+');
    Matcher MyMatcherOpportunity = MyPatternOpportunity.matcher(recordId);
    boolean isOpportunity = MyMatcherOpportunity.matches();

    String recordOwnerId = '';
    if (isAccount == true) {
      List<Account> u = [
        SELECT ownerId
        FROM account
        WHERE id = :recordId
        LIMIT 1
      ];
      recordOwnerId = u[0].ownerId;
    } else if (isOpportunity == true) {
      List<Opportunity> u = [
        SELECT ownerId
        FROM opportunity
        WHERE id = :recordId
        LIMIT 1
      ];
      recordOwnerId = u[0].ownerId;
    } else if (isContact == true) {
      List<Contact> u = [
        SELECT ownerId
        FROM contact
        WHERE id = :recordId
        LIMIT 1
      ];
      recordOwnerId = u[0].ownerId;
    }

    return [
      SELECT id, name
      FROM user
      WHERE usertype = 'Standard' AND id != :recordOwnerId
    ];
  }
}
