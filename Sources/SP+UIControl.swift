//
//  UIControl+Externsion.swift
//  Pods
//
//  Created by BigL on 2017/7/12.
//
//

import UIKit
import BLFoundation

public extension UIControl {
  public func add(for event: UIControlEvents,
                  action: @escaping () -> ()) {
    guard let selector = selector(event: event) else { return }
    let act = ActionBlock(key: event.rawValue, action: action)
    actionBlocks = actionBlocks.filter { (item) -> Bool in
      return item.key != act.key
    }
    actionBlocks.append(act)
    self.addTarget(self, action: selector, for: event)
  }
  
}


// MARK: - runtime keys
extension UIControl {
  private static var once: Bool = false
  
  public class func begin() {
    if once == false {
      once = true
      RunTime.exchangeMethod(selector: #selector(UIControl.sendAction(_:to:for:)),
                             replace: #selector(UIControl.sp_sendAction(action:to:forEvent:)),
                             class: UIControl.self)
    }
  }
  
  private struct ActionKey {
    static var action = UnsafeRawPointer(bitPattern: "uicontrol_action_block".hashValue)
    static var time = UnsafeRawPointer(bitPattern: "uicontrol_event_time".hashValue)
    static var interval = UnsafeRawPointer(bitPattern: "uicontrol_event_interval".hashValue)
  }
}

// MARK: - time
extension UIControl {
  
  /// 系统响应事件
  private var systemActions: [String] {
    return ["_handleShutterButtonReleased:",
            "cameraShutterPressed:",
            "_tappedBottomBarCancelButton:",
            "_tappedBottomBarDoneButton:",
            "recordStart:",
            "btnTouchUp:withEvent:"]
  }
  
  // 重复点击的间隔
  public var eventInterval: TimeInterval {
    get {
      if let eventInterval = objc_getAssociatedObject(self,
                                                      UIControl.ActionKey.interval!) as? TimeInterval {
        return eventInterval
      }
      return 0
    }
    set {
      objc_setAssociatedObject(self,
                               UIControl.ActionKey.interval!,
                               newValue as TimeInterval,
                               .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  /// 上次事件响应时间
  private var lastEventTime: TimeInterval {
    get {
      if let eventTime = objc_getAssociatedObject(self, UIControl.ActionKey.time!) as? TimeInterval {
        return eventTime
      }
      return 1.0
    }
    set {
      objc_setAssociatedObject(self,
                               UIControl.ActionKey.time!,
                               newValue as TimeInterval,
                               .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  @objc private func sp_sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
    if systemActions.contains(action.description) || eventInterval <= 0 {
      self.sp_sendAction(action: action, to: target, forEvent: event)
      return
    }
    
    let nowTime = Date().timeIntervalSince1970
    if nowTime - lastEventTime < eventInterval { return }
    if eventInterval > 0 { lastEventTime = nowTime }
    self.sp_sendAction(action: action, to: target, forEvent: event)
  }
  
}

// MARK: - target
extension UIControl {
  
  private struct ActionBlock {
    var key: UInt
    var action: ()->()
  }
  
  private var actionBlocks: [ActionBlock] {
    get { return objc_getAssociatedObject(self,UIControl.ActionKey.action!) as? [ActionBlock] ?? [] }
    set { objc_setAssociatedObject(self,
                                   UIControl.ActionKey.action!,
                                   newValue as [ActionBlock],
                                   .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  private func triggerAction(for: UIControl, event: UIControlEvents){
    let action = actionBlocks.filter { (item) -> Bool
      in return item.key == event.rawValue
      }.first
    guard let act = action else { return }
    act.action()
  }
  
  private func selector(event: UIControlEvents) -> Selector? {
    var selector: Selector?
    switch event.rawValue {
    // Touch events
    case 1 << 0: selector = #selector(touchDown(sender:))
    case 1 << 1: selector = #selector(touchDownRepeat(sender:))
    case 1 << 2: selector = #selector(touchDragInside(sender:))
    case 2 << 2: selector = #selector(touchDragOutside(sender:))
    case 2 << 3: selector = #selector(touchDragEnter(sender:))
    case 2 << 4: selector = #selector(touchDragExit(sender:))
    case 2 << 5: selector = #selector(touchUpInside(sender:))
    case 2 << 6: selector = #selector(touchUpOutside(sender:))
    case 2 << 7: selector = #selector(touchCancel(sender:))
    // UISlider events
    case 2 << 11: selector = #selector(valueChanged(sender:))
    // TV event
    case 2 << 12: selector = #selector(primaryActionTriggered(sender:))
    // UITextField events
    case 2 << 15: selector = #selector(editingDidBegin(sender:))
    case 2 << 16: selector = #selector(editingChanged(sender:))
    case 2 << 17: selector = #selector(editingDidEnd(sender:))
    case 2 << 18: selector = #selector(editingDidEndOnExit(sender:))
    // Other events
    case 4095:       selector = #selector(allTouchEvents(sender:))
    case 983040:     selector = #selector(allEditingEvents(sender:))
    case 251658240:  selector = #selector(applicationReserved(sender:))
    case 4026531840: selector = #selector(systemReserved(sender:))
    case 4294967295: selector = #selector(allEvents(sender:))
    default: selector = nil
    }
    return selector
  }
  
  @objc private func touchDown(sender: UIControl) {
    triggerAction(for: sender, event: .touchDown)
  }
  @objc private func touchDownRepeat(sender: UIControl) {
    triggerAction(for:sender, event: .touchDownRepeat)
  }
  @objc private func touchDragInside(sender: UIControl) {
    triggerAction(for:sender, event: .touchDragInside)
  }
  @objc private func touchDragOutside(sender: UIControl) {
    triggerAction(for:sender, event: .touchDragOutside)
  }
  @objc private func touchDragEnter(sender: UIControl) {
    triggerAction(for:sender, event: .touchDragEnter)
  }
  @objc private func touchDragExit(sender: UIControl) {
    triggerAction(for:sender, event: .touchDragExit)
  }
  @objc private func touchUpInside(sender: UIControl) {
    triggerAction(for:sender, event: .touchUpInside)
  }
  @objc private func touchUpOutside(sender: UIControl) {
    triggerAction(for:sender, event: .touchUpOutside)
  }
  @objc private func touchCancel(sender: UIControl) {
    triggerAction(for:sender, event: .touchCancel)
  }
  @objc private func valueChanged(sender: UIControl) {
    triggerAction(for:sender, event: .valueChanged)
  }
  @objc private func primaryActionTriggered(sender: UIControl) {
    if #available(iOS 9.0, *) {
      triggerAction(for:sender, event: .primaryActionTriggered)
    }
  }
  @objc private func editingDidBegin(sender: UIControl) {
    triggerAction(for:sender, event: .editingDidBegin)
  }
  @objc private func editingChanged(sender: UIControl) {
    triggerAction(for:sender, event: .editingChanged)
  }
  @objc private func editingDidEnd(sender: UIControl) {
    triggerAction(for:sender, event: .editingDidEnd)
  }
  @objc private func editingDidEndOnExit(sender: UIControl) {
    triggerAction(for:sender, event: .editingDidEndOnExit)
  }
  @objc private func allTouchEvents(sender: UIControl) {
    triggerAction(for:sender, event: .allTouchEvents)
  }
  @objc private func allEditingEvents(sender: UIControl) {
    triggerAction(for:sender, event: .allEditingEvents)
  }
  @objc private func applicationReserved(sender: UIControl) {
    triggerAction(for:sender, event: .applicationReserved)
  }
  @objc private func systemReserved(sender: UIControl) {
    triggerAction(for:sender, event: .systemReserved)
  }
  @objc private func allEvents(sender: UIControl) {
    triggerAction(for:sender, event: .allEvents)
  }
  
}
