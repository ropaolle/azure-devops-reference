import { describe, expect, test } from "@jest/globals";
import fibonacci from "./fibonacci";

describe("fibonacci module", () => {
  test("fibonacci should work", () => {
    expect(fibonacci(10, [])).toBe(55);
  });
});
