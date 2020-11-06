class Feature {
  ///output of a feature e.g a consumable
  var output;

  ///conditions for triggers a features output
  Function outputTrigger;

  Feature(var output, Function outputTrigger) {
    this.output = output;
    this.outputTrigger = outputTrigger;
  }
}
