void setupPubNubHandlers() {
  PNConfiguration pnConfiguration = new PNConfiguration();
  pnConfiguration.setSubscribeKey("INSERT-KEY-HERE");

  PubNub pubnub = new PubNub(pnConfiguration);
  pubnub.addListener(new SubscribeCallback() {
    @Override
      public void status(PubNub pubnub, PNStatus status) {
      // nothing
    }

    @Override
      public void message(PubNub pubnub, PNMessageResult message) {
      String msg = message.getMessage().getAsJsonObject().get("message").getAsString();
      if (msg.equals("radial")) {
        effects.triggerWipe(4);
      } else if (msg.equals("vertical")) {
        effects.triggerWipe(random(0, 1) > 0.5 ? 2 : 3);
      } else if (msg.equals("horizontal")) {
        effects.triggerWipe(random(0, 1) > 0.5 ? 0 : 1);
      } else if (msg.equals("increaseDecay")) {
        effects.wipeDecay.incrementValue(1000d);
      } else if (msg.equals("decreaseDecay")) {
        effects.wipeDecay.incrementValue(-1000d);
      }
    }

    @Override
      public void presence(PubNub pubnub, PNPresenceEventResult presence) {
    }
  }
  );
  ArrayList list = new ArrayList();
  list.add("ch1");
  pubnub.subscribe().channels(list).execute();
}
