//
//  FlexDashedLineView.swift
//  OTCBaseUI
//
//  Created by xmy on 2024/5/5.
//

import UIKit

public class FlexDashedLineView: FlexView {
    public var strokeColor: UIColor? = .black
    public var lineWidth: CGFloat = 1
    public var lineDashPattern: [CGFloat]?
    /// 0 - 1
    public var startPoint: CGPoint = .zero
    /// 0 - 1
    public var endPoint: CGPoint = .zero
    
    override public func view(from node: FlexNode) -> UIView {
        let view = super.view(from: node)
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: view.bounds.width * startPoint.x, y: view.bounds.height * startPoint.y))
        linePath.addLine(to: CGPoint(x: view.bounds.width * endPoint.x, y: view.bounds.height * endPoint.y))
        line.path = linePath.cgPath
        line.strokeColor = strokeColor?.cgColor
        line.lineWidth = lineWidth
        line.lineJoin = .round
        line.lineDashPattern = lineDashPattern?.map { NSNumber(floatLiteral: $0) }
        view.layer.addSublayer(line)
        return view
    }
}
