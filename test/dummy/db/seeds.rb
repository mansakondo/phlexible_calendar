Event.create name: "Interview 1", start_time: Time.now, end_time: Time.now.advance(minutes: 15)
Event.create name: "Interview 2", start_time: Time.now.advance(days: 1, minutes: 15), end_time: Time.now.advance(days: 1, minutes: 45)
Event.create name: "Interview 3", start_time: Time.now.advance(days: 2, minutes: 30), end_time: Time.now.advance(days: 2, minutes: 75)
