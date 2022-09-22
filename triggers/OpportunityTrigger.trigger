trigger OpportunityTrigger on Opportunity(before update) {
  OpportunityTriggerHelper.validateOwnership(Trigger.old, Trigger.new);
}