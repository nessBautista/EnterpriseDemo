//
//  ActionsTapGestureRecognizer.swift
//  EntrepriseDemo
//
//  Created by Nestor Hernandez on 9/4/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit

class ActionsTapGestureRecognizer: UITapGestureRecognizer
{
    var tapAction: ActionTap
    
    init(onTap:@escaping () -> ())
    {
        self.tapAction = ActionTap()
        self.tapAction.onTap = onTap
        super.init(target: self.tapAction, action: #selector(ActionTap.launchActionOnTap))
    }
}

class ActionTap : NSObject
{
    var onTap: (() -> ())?
    var onLongPress: ((_ state: UIGestureRecognizerState)->())?
    
    @objc func launchActionOnTap()
    {
        onTap?()
    }
    
    @objc func launchActionForLongTapGesture(_ sender:UILongPressGestureRecognizer)
    {
        if sender.state == .began || sender.state == .ended
        {
            onLongPress?(sender.state)
        }
    }
}

class ActionsLongGestureRecognizer: UILongPressGestureRecognizer
{
    var tapAction: ActionTap
    
    init(onTap:@escaping (_ state: UIGestureRecognizerState)->())
    {
        self.tapAction = ActionTap()
        self.tapAction.onLongPress = onTap
        super.init(target: self.tapAction, action: #selector(ActionTap.launchActionForLongTapGesture))
    }
}

