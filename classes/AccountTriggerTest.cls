@isTest
public with sharing class AccountTriggerTest {
  @TestSetup
  static void makeData() {
    /* Crea due utenti */
    Profile p = [SELECT id FROM profile WHERE name = 'Standard User'];
    List<User> users = new List<User>();
    User utenteProprietario = new User(
      ProfileId = p.id,
      LastName = 'Utente proprietario',
      email = 'standarduser@testorg.com',
      Username = 'proprietario@visioture.com',
      TimeZoneSidKey = 'America/Los_Angeles',
      EmailEncodingKey = 'UTF-8',
      Alias = 'user1',
      LocaleSidKey = 'en_US',
      LanguageLocaleKey = 'en_US'
    );
    User utenteCheRiceve = new User(
      ProfileId = p.id,
      LastName = 'Utente che riceve',
      email = 'standarduser@testorg.com',
      Username = 'ricevente@visioture.com',
      TimeZoneSidKey = 'America/Los_Angeles',
      EmailEncodingKey = 'UTF-8',
      Alias = 'user1',
      LocaleSidKey = 'en_US',
      LanguageLocaleKey = 'en_US'
    );
    users.add(utenteProprietario);
    users.add(utenteCheRiceve);
    insert users;

    /* Crea account */
    List<Account> accs = new List<Account>();
    Account account1 = new Account(name = 'AccountProprietario');
    accs.add(account1);
    insert accs;

    /* Crea opportunity e contact associati a quell'account e all'utente proprietario */
    List<Opportunity> opps = new List<Opportunity>();
    opps.add(
      new Opportunity(
        ownerId = utenteProprietario.id,
        accountId = account1.id,
        name = 'Opp1',
        stageName = 'Prospecting',
        closeDate = Date.newInstance(2022, 10, 10)
      )
    );
    List<Contact> cons = new List<Contact>();
    cons.add(
      new Contact(
        ownerId = utenteProprietario.id,
        accountId = account1.id,
        LastName = 'ContactName'
      )
    );
    insert opps;
    insert cons;
  }

  @isTest
  public static void makeTest() {
    Account a = [SELECT id, ownerId FROM account LIMIT 1];
    User utenteCheRiceve = [
      SELECT id FROM user
      WHERE name = 'Utente che riceve'
    ];

    a.ownerId = utenteCheRiceve.id; // Cambio owner

    test.StartTest();
    update a;
    test.StopTest();

    Contact c = [SELECT id, ownerId FROM contact LIMIT 1];
    Opportunity o = [SELECT id, ownerId FROM opportunity LIMIT 1];

    System.assert(
      c.ownerId == utenteCheRiceve.id,
      'L\' owner di Contact non è cambiato'
    );
    System.assert(
      o.ownerId == utenteCheRiceve.id,
      'L\' owner di Opportunity non è cambiato'
    );
  }
}
