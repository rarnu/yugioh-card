//
//  DatetimeUtils.swift
//  sfunctional
//
//  Created by rarnu on 27/03/2018.
//  Copyright © 2018 rarnu. All rights reserved.
//

import UIKit

public extension Date {
    func addYear(_ year: Int) -> Date {
        let c = Calendar.current
        return c.date(byAdding: Calendar.Component.year, value: year, to: self)!
    }
    
    func addMonth(_ month: Int) -> Date {
        let c = Calendar.current
        return c.date(byAdding: Calendar.Component.month, value: month, to: self)!
    }
    
    func addDay(_ day: Int) -> Date {
        let c = Calendar.current
        return c.date(byAdding: Calendar.Component.day, value: day, to: self)!
    }
    
    func addHour(_ hour: Int) -> Date {
        let c = Calendar.current
        return c.date(byAdding: Calendar.Component.hour, value: hour, to: self)!
    }
    
    func addMinute(_ minute: Int) -> Date {
        let c = Calendar.current
        return c.date(byAdding: Calendar.Component.minute, value: minute, to: self)!
    }
    
    func addSecond(_ second: Int) -> Date {
        let c = Calendar.current
        return c.date(byAdding: Calendar.Component.second, value: second, to: self)!
    }
    
    func addMilliSecond(_ millisecond: Int) -> Date {
        let c = Calendar.current
        return c.date(byAdding: Calendar.Component.nanosecond, value: millisecond, to: self)!
    }
    
}

