@isTest
public with sharing class ContactTriggerHelperTest {
  @TestSetup
  static void makeData() {
    profile p = [SELECT id FROM profile WHERE name = 'standard user'];
    list<user> us = new List<User>();
    us.add(
      new user(
        profileid = p.id,
        LastName = 'pippo',
        email = 'pippo@gmail.com',
        Username = 'proprietario@visioture.com',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        Alias = 'user1',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
      )
    );
    us.add(
      new user(
        profileid = p.id,
        LastName = 'baudo',
        email = 'baudo@gmail.com',
        Username = 'nonproprietario@visioture.com',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        Alias = 'user2',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
      )
    );
    insert us;
    list<contact> con = new List<Contact>();
    List<Account> acc = new List<Account>();
    List<Opportunity> op = new List<Opportunity>();
    acc.add(new account(name = 'rotolone', ownerid = us[0].id));
    acc.add(new account(name = 'regina', ownerid = us[1].id));
    insert acc;
    for (integer i = 0; i < 5; i++) {
      con.add(new Contact(LastName = 'pippo' + i, accountid = acc[0].id));
    }
    insert con;
    for (integer i = 0; i < 5; i++) {
      op.add(
        new Opportunity(
          name = 'pippo' + i,
          stagename = 'closed won',
          closedate = date.today(),
          accountid = acc[0].id
        )
      );
    }
    insert op;
  }

  @isTest
  public static void makeTest() {
    account a = [SELECT ownerid FROM account WHERE name = 'regina'];
    List<Contact> con1 = [SELECT name, ownerid FROM Contact];
    List<Contact> con2 = [SELECT name, ownerid FROM Contact];
    con2[4].accountid = a.id;
    test.startTest();
    ContactTriggerHelper.validateOwnership(con1, con2);
    test.stopTest();
  }
}
