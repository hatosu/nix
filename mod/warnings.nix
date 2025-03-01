{ lib, ... }: {

  options = {
    warnings = lib.mkOption {
      apply = lib.filter (
        w: !(lib.strings.hasInfix "If multiple of these password options are set at the same time" w)
      );
    };
  };

}
