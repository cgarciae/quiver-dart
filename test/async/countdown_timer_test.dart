// Copyright 2013 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library quiver.async.countdown_timer_test;

import 'dart:async';

import 'package:unittest/unittest.dart';
import 'package:quiver/async.dart';

main() {

  group('CountdownTimer', () {

    test('should countdown', () {
      int round100(i) => (i / 100).round();

      var stopwatch = new Stopwatch()..start();
      var countdown = new CountdownTimer(
          new Duration(milliseconds: 500),
          new Duration(milliseconds: 100))
          .map((c) => round100(c.remaining.inMilliseconds));
      return Future.wait([
          countdown.toList(),
          countdown.map((t) => t + round100(stopwatch.elapsedMilliseconds))
              .toList()])
          .then((l) {
            // the ticks should be 4 .. 0
            expect(l[0], [4, 3, 2, 1, 0]);
            // they should come roughly every 100ms
            expect(l[1], [5, 5, 5, 5, 5]);
          });
    });
  });
}
