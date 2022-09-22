@isTest
public with sharing class AccountTriggerHelperTest {
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
        for (integer i = 0; i < 10; i++) {
            opps.add(new Opportunity(ownerId = utenteProprietario.id, accountId = account1.id, name = 'Opp' + i, stageName = 'Prospecting', closeDate = Date.newInstance(2022, 10, 10)));
        }

        List<Contact> cons = new List<Contact>();
        for (integer i = 0; i < 10; i++) {
            cons.add(new Contact(ownerId = utenteProprietario.id, accountId = account1.id, LastName = 'ContactName' + i));
        }
        insert opps;
        insert cons;
    }

    @isTest
    public static void makeTest() {
        List<Account> triggerOld = [SELECT id, ownerId FROM account];
        List<Account> triggerNew = [SELECT id, ownerId FROM account];

        User utenteCheRiceve = [SELECT id FROM user WHERE name = 'Utente che riceve'];

        for (Account a : triggerNew) {
            a.ownerId = utenteCheRiceve.id; // Cambio owner
        }

        test.StartTest();
        AccountTriggerHelper.changeOwnerOnChildren(triggerOld, triggerNew);
        test.StopTest();
    }
}
