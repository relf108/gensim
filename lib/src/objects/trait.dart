///Traits are genetic
///The value of an actors trait cannot change during its lifespan
class Trait {
  var name;
  var value;
  var maxValue;

  Trait(var name, var value, var maxValue) {
    this.name = name;
    this.value = value;
    this.maxValue = maxValue;
  }

  ///Returns a new Trait instance with the same values as the passed in one.
  Trait.clone(Trait other) {
    name = other.name;
    value = other.value;
    maxValue = other.maxValue;
  }
}
