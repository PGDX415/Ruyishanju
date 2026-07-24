//
//  ContactView.swift
//  Ruyishanju
//
//  联系与预约看房
//

import SwiftUI

struct ContactView: View {
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var interest: String = ""
    @State private var visitDate: Date = Date()
    @State private var remarks: String = ""
    @State private var agreePrivacy: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 联系信息
                    contactInfoSection

                    // 预约表单
                    bookingFormSection

                    // 展厅信息
                    showroomInfo
                }
                .padding(16)
            }
            .background(AppTheme.background)
            .navigationTitle("预约看房")
            .navigationBarTitleDisplayMode(.large)
            .alert("提示", isPresented: $showAlert) {
                Button("确定", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    // MARK: - 联系方式

    private var contactInfoSection: some View {
        VStack(spacing: 12) {
            HStack {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 16)
                Text("联系信息")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
            }

            HStack(spacing: 14) {
                Link(destination: URL(string: "tel://4008888888")!) {
                    ContactMethodCard(
                        icon: "phone.fill",
                        title: "电话咨询",
                        value: "400-888-8888",
                        color: AppTheme.primary
                    )
                }
                .buttonStyle(.plain)

                ContactMethodCard(
                    icon: "clock.fill",
                    title: "接待时间",
                    value: "09:00-20:00",
                    color: AppTheme.wood
                )
            }
        }
    }

    // MARK: - 预约表单

    private var bookingFormSection: some View {
        VStack(spacing: 16) {
            HStack {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 16)
                Text("在线预约")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
            }

            VStack(spacing: 14) {
                FormField(title: "姓名", text: $name, placeholder: "请输入您的姓名")
                FormField(title: "手机号", text: $phone, placeholder: "请输入手机号码", keyboardType: .phonePad)
                FormField(title: "意向户型", text: $interest, placeholder: "如：三室两厅")

                VStack(alignment: .leading, spacing: 6) {
                    Text("期望看房时间")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(AppTheme.textSecondary)

                    DatePicker("", selection: $visitDate, displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                        .tint(AppTheme.primary)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("备注")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(AppTheme.textSecondary)

                    TextEditor(text: $remarks)
                        .font(.system(size: 14))
                        .frame(height: 80)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(AppTheme.divider, lineWidth: 1)
                        )
                        .scrollContentBackground(.hidden)
                        .background(Color.white)
                }

                // 隐私政策
                HStack(spacing: 6) {
                    Button {
                        agreePrivacy.toggle()
                    } label: {
                        Image(systemName: agreePrivacy ? "checkmark.square.fill" : "square")
                            .font(.system(size: 18))
                            .foregroundColor(agreePrivacy ? AppTheme.primary : AppTheme.textSecondary.opacity(0.5))
                    }

                    Text("我已阅读并同意")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)

                    NavigationLink("《隐私政策》") {
                        PrivacyView()
                    }
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.primary)
                }

                // 提交按钮
                Button(action: submitBooking) {
                    Text("提交预约")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppTheme.primary)
                        )
                }
                .disabled(!agreePrivacy)
                .opacity(agreePrivacy ? 1.0 : 0.5)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
    }

    // MARK: - 展厅信息

    private var showroomInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 16)
                Text("营销中心")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 10) {
                Label("南山风景区·如意路88号", systemImage: "mappin.and.ellipse")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)

                Label("09:00 - 20:00（全年无休）", systemImage: "clock")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)

                Label("地铁3号线南山站B出口步行12分钟", systemImage: "tram.fill")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
    }

    // MARK: - 提交

    private func submitBooking() {
        guard !name.isEmpty, !phone.isEmpty else {
            alertMessage = "请填写姓名和手机号"
            showAlert = true
            return
        }
        alertMessage = "预约信息已提交，销售顾问将尽快与您联系。"
        showAlert = true
        // 重置表单
        name = ""
        phone = ""
        interest = ""
        remarks = ""
    }
}

// MARK: - 子组件

struct ContactMethodCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
                .frame(height: 28)

            Text(title)
                .font(.system(size: 12))
                .foregroundColor(AppTheme.textSecondary)

            Text(value)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(AppTheme.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)

            TextField(placeholder, text: $text)
                .font(.system(size: 14))
                .keyboardType(keyboardType)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AppTheme.divider, lineWidth: 1)
                )
                .background(Color.white)
        }
    }
}

#Preview {
    ContactView()
}
