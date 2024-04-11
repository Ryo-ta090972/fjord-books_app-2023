# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:system_test_report)

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: @report.title
    fill_in '内容', with: @report.content
    click_on '登録する'

    assert_text '日報が作成されました。'
    click_on '日報の一覧に戻る'
  end

  test 'should error create report in nothing title and content' do
    visit reports_url
    click_on '日報の新規作成'
    click_on '登録する'

    assert_text '2件のエラーがあるため、この日報は保存できませんでした:'
    assert_text 'タイトルを入力してください'
    assert_text '内容を入力してください'
    click_on '日報の一覧に戻る'
  end

  test 'should error create report in nothing title' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in '内容', with: @report.content
    click_on '登録する'

    assert_text '1件のエラーがあるため、この日報は保存できませんでした:'
    assert_text 'タイトルを入力してください'
    click_on '日報の一覧に戻る'
  end

  test 'should error create report in nothing content' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: @report.title
    click_on '登録する'

    assert_text '1件のエラーがあるため、この日報は保存できませんでした:'
    assert_text '内容を入力してください'
    click_on '日報の一覧に戻る'
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on 'この日報を編集', match: :first
    new_title = 'タイトルを変更'
    new_content = '内容を変更'

    fill_in 'タイトル', with: new_title
    fill_in '内容', with: new_content
    click_on '更新する'

    assert_text '日報が更新されました。'
    click_on '日報の一覧に戻る'
  end

  test 'should error update Report in nothing title and content' do
    visit report_url(@report)
    click_on 'この日報を編集', match: :first
    new_title = ''
    new_content = ''

    fill_in 'タイトル', with: new_title
    fill_in '内容', with: new_content
    click_on '更新する'

    assert_text '2件のエラーがあるため、この日報は保存できませんでした:'
    assert_text 'タイトルを入力してください'
    assert_text '内容を入力してください'
    click_on '日報の一覧に戻る'
  end

  test 'should error update Report in nothing title' do
    visit report_url(@report)
    click_on 'この日報を編集', match: :first
    new_title = ''
    new_content = '内容を変更'

    fill_in 'タイトル', with: new_title
    fill_in '内容', with: new_content
    click_on '更新する'

    assert_text '1件のエラーがあるため、この日報は保存できませんでした:'
    assert_text 'タイトルを入力してください'
    click_on '日報の一覧に戻る'
  end

  test 'should error update Report in nothing content' do
    visit report_url(@report)
    click_on 'この日報を編集', match: :first
    new_title = 'タイトルを変更'
    new_content = ''

    fill_in 'タイトル', with: new_title
    fill_in '内容', with: new_content
    click_on '更新する'

    assert_text '1件のエラーがあるため、この日報は保存できませんでした:'
    assert_text '内容を入力してください'
    click_on '日報の一覧に戻る'
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'この日報を削除', match: :first

    assert_text '日報が削除されました。'
  end
end
