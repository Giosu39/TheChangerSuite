@isTest
public with sharing class OpportunityTriggerTest {
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
  
      /* Crea opportunity figlio di quell'account e owner utente proprietario */
      
      List<Opportunity> opps = new List<Opportunity>();
      opps.add(
        new Opportunity(
          ownerId = utenteProprietario.id,
          accountId = account1.id,
          Name = 'OpportunityName',
          CloseDate = Date.newInstance(2022,10,10),
          StageName = 'Prospecting'
        )
      );
      insert opps;
    }
  
    @isTest
    public static void makeTest() {
      Opportunity c = [SELECT id, ownerId FROM Opportunity LIMIT 1];
      User utenteCheRiceve = [
        SELECT id 
        FROM user
        WHERE name = 'Utente che riceve'
      ];
  
      c.ownerId = utenteCheRiceve.id; // Cambio owner
  
      test.StartTest();
      update c;
      test.StopTest();
    }
    
}
