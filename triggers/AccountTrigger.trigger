trigger AccountTrigger on Account(after update) {
  if (Trigger.isUpdate && Trigger.isAfter) {
    AccountTriggerHelper.changeOwnerOnChildren(Trigger.old, Trigger.new);
  }
}