trigger ContactTrigger on Contact(before update) {
  ContactTriggerHelper.validateOwnership(Trigger.old, Trigger.new);
}