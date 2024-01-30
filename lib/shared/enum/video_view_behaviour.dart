enum VideoViewBehaviour { pausable, holdToPause }

extension VideoViewBehaviourGetters on VideoViewBehaviour {
  bool get isPausable => this == VideoViewBehaviour.pausable;
  bool get isHoldToPause => this == VideoViewBehaviour.holdToPause;
}
