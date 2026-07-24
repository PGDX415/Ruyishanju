//
//  MortgageView.swift
//  Ruyishanju
//
//  房贷计算器 — 等额本息 / 等额本金
//

import SwiftUI

struct MortgageView: View {
    @State private var totalPrice: Double = 135
    @State private var downPaymentRatio: Double = 30
    @State private var loanYears: Int = 20
    @State private var annualRate: Double = 3.6
    @State private var repaymentMethod: RepaymentMethod = .equalInstallment

    enum RepaymentMethod: String, CaseIterable {
        case equalInstallment = "等额本息"
        case equalPrincipal = "等额本金"
    }

    // MARK: - 计算结果

    private var downPayment: Double {
        (totalPrice * 10000 * downPaymentRatio / 100).rounded()
    }

    private var loanAmount: Double {
        (totalPrice * 10000 - downPayment).rounded()
    }

    private var monthlyRate: Double {
        annualRate / 100 / 12
    }

    private var totalMonths: Int {
        loanYears * 12
    }

    /// 等额本息月供
    private var equalInstallmentPayment: Double {
        let r = monthlyRate
        let n = Double(totalMonths)
        let p = loanAmount
        guard r > 0 else { return p / n }
        let factor = pow(1 + r, n)
        return (p * r * factor) / (factor - 1)
    }

    /// 等额本金首月月供
    private var equalPrincipalFirstPayment: Double {
        let principal = loanAmount / Double(totalMonths)
        let interest = loanAmount * monthlyRate
        return principal + interest
    }

    /// 等额本金末月月供
    private var equalPrincipalLastPayment: Double {
        let principal = loanAmount / Double(totalMonths)
        let interest = principal * monthlyRate
        return principal + interest
    }

    private var currentMonthlyPayment: Double {
        switch repaymentMethod {
        case .equalInstallment:
            return equalInstallmentPayment
        case .equalPrincipal:
            return equalPrincipalFirstPayment
        }
    }

    /// 总利息
    private var totalInterest: Double {
        switch repaymentMethod {
        case .equalInstallment:
            return (equalInstallmentPayment * Double(totalMonths) - loanAmount)
        case .equalPrincipal:
            var total: Double = 0
            let principalPerMonth = loanAmount / Double(totalMonths)
            var remaining = loanAmount
            for _ in 0..<totalMonths {
                total += remaining * monthlyRate
                remaining -= principalPerMonth
            }
            return total
        }
    }

    private var totalRepayment: Double {
        loanAmount + totalInterest
    }

    // MARK: - 格式化金额

    private func formatWan(_ value: Double) -> String {
        let wan = value / 10000
        if wan >= 1 {
            return String(format: "%.1f 万", wan)
        }
        return String(format: "%.0f 元", value)
    }

    private func formatMoney(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    inputSection
                    resultSection
                    breakdownSection
                }
                .padding(16)
            }
            .background(AppTheme.background)
            .navigationTitle("房贷计算器")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - 输入区

    private var inputSection: some View {
        VStack(spacing: 16) {
            // 房屋总价
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("房屋总价")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)
                    Spacer()
                    Text("\(formatWan(totalPrice * 10000))")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(AppTheme.wood)
                }

                HStack {
                    // 快速预设
                    ForEach([100.0, 120.0, 135.0, 160.0], id: \.self) { price in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                totalPrice = price
                            }
                        } label: {
                            Text(formatWan(price * 10000).replacingOccurrences(of: " 万", with: "万"))
                                .font(.system(size: 12, weight: totalPrice == price ? .semibold : .regular))
                                .foregroundColor(totalPrice == price ? .white : AppTheme.textSecondary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule()
                                        .fill(totalPrice == price ? AppTheme.primary : AppTheme.surface)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }

                Slider(value: $totalPrice, in: 50...500, step: 1)
                    .tint(AppTheme.primary)
            }

            // 首付比例
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("首付比例")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)
                    Spacer()
                    Text("\(Int(downPaymentRatio))%")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(AppTheme.primary)
                }

                HStack(spacing: 8) {
                    ForEach([20.0, 30.0, 40.0, 50.0], id: \.self) { ratio in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                downPaymentRatio = ratio
                            }
                        } label: {
                            Text("\(Int(ratio))%")
                                .font(.system(size: 12, weight: downPaymentRatio == ratio ? .semibold : .regular))
                                .foregroundColor(downPaymentRatio == ratio ? .white : AppTheme.textSecondary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule()
                                        .fill(downPaymentRatio == ratio ? AppTheme.primary : AppTheme.surface)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }

                Slider(value: $downPaymentRatio, in: 10...80, step: 5)
                    .tint(AppTheme.primary)
            }

            // 贷款年限
            HStack {
                Text("贷款年限")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Picker("", selection: $loanYears) {
                    ForEach([5, 10, 15, 20, 25, 30], id: \.self) { year in
                        Text("\(year)年").tag(year)
                    }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 280)
            }

            // 贷款利率
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("贷款利率（年）")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)
                    Spacer()
                    Text(String(format: "%.2f%%", annualRate))
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(AppTheme.wood)
                }

                Slider(value: $annualRate, in: 2.0...6.0, step: 0.05)
                    .tint(AppTheme.primary)

                HStack {
                    Text("当前LPR基准：3.60%")
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.textSecondary.opacity(0.6))
                    Spacer()
                    Button("恢复默认") {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            annualRate = 3.6
                        }
                    }
                    .font(.system(size: 11))
                    .foregroundColor(AppTheme.primary)
                }
            }

            // 还款方式
            HStack {
                Text("还款方式")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Picker("", selection: $repaymentMethod) {
                    ForEach(RepaymentMethod.allCases, id: \.self) { method in
                        Text(method.rawValue).tag(method)
                    }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 240)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.cardBackground)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }

    // MARK: - 结果区

    private var resultSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 10) {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 18)
                Text("计算结果")
                    .font(.brandSubtitle)
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
            }

            // 月供
            VStack(spacing: 4) {
                Text("月供")
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("¥")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppTheme.wood)
                    Text(formatMoney(currentMonthlyPayment))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.wood)
                }

                if repaymentMethod == .equalPrincipal {
                    Text("首月 ¥\(formatMoney(equalPrincipalFirstPayment)) → 末月 ¥\(formatMoney(equalPrincipalLastPayment))")
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.textSecondary)
                } else {
                    Text("每月固定还款额")
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppTheme.wood.opacity(0.06))
            )

            // 四格数据
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                resultItem(title: "首付金额", value: "¥\(formatMoney(downPayment))")
                resultItem(title: "贷款金额", value: "¥\(formatMoney(loanAmount))")
                resultItem(title: "支付利息", value: "¥\(formatMoney(totalInterest))")
                resultItem(title: "还款总额", value: "¥\(formatMoney(totalRepayment))")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.cardBackground)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }

    // MARK: - 明细区

    private var breakdownSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 18)
                Text("还款概览")
                    .font(.brandSubtitle)
                    .foregroundColor(AppTheme.textPrimary)
            }

            VStack(spacing: 0) {
                breakdownRow(label: "房屋总价", value: "¥\(formatMoney(totalPrice * 10000))")
                Divider().background(AppTheme.divider)
                breakdownRow(label: "首付（\(Int(downPaymentRatio))%）", value: "¥\(formatMoney(downPayment))")
                Divider().background(AppTheme.divider)
                breakdownRow(label: "贷款总额", value: "¥\(formatMoney(loanAmount))")
                Divider().background(AppTheme.divider)
                breakdownRow(label: "贷款年限", value: "\(loanYears)年（\(totalMonths)期）")
                Divider().background(AppTheme.divider)
                breakdownRow(label: "年利率", value: String(format: "%.2f%%", annualRate))
                Divider().background(AppTheme.divider)
                breakdownRow(label: "还款方式", value: repaymentMethod.rawValue)
                Divider().background(AppTheme.divider)
                breakdownRow(label: "月均还款", value: "¥\(formatMoney(currentMonthlyPayment))", highlight: true)
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppTheme.cardBackground)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
        .padding(.bottom, 24)
    }

    // MARK: - 辅助组件

    private func resultItem(title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(AppTheme.textSecondary)
            Text(value)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(AppTheme.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(AppTheme.surface.opacity(0.5))
        )
    }

    private func breakdownRow(label: String, value: String, highlight: Bool = false) -> some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: highlight ? .semibold : .medium, design: highlight ? .rounded : .default))
                .foregroundColor(highlight ? AppTheme.wood : AppTheme.textPrimary)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
    }
}

#Preview {
    MortgageView()
}
