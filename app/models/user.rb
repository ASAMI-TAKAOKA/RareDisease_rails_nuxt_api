class User < ApplicationRecord
  # gem bcryptのメソッド
  # 1. passwordを暗号化することができる
  # 2. password_digestをpasswordに変換してくれる
  # 3. password_confirmationという仮想属性を使用できる。これはパスワードの一致確認をするためのもの。
  # 4. 一致のバリデーション追加
  # 5. authenticate()を追加
  # 6. 最大文字数 72文字まで
  # 7. User.create()つまり新規登録時の入力必須バリデーションの追加。User.updateつまり更新時は適用されない。
  has_secure_password

  # validates
  validates :name, presence: true,
                    length: { 
                      maximum: 30,
                      allow_blank: true # 空白文字が入力されている場合は文字数成約を適用しない
                    }

  VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
  validates :password, presence: true,
                        length: { minimum: 8 },
                        format: {
                          with: VALID_PASSWORD_REGEX,
                          message: :invalid_password,
                          allow_blank: true
                        },
                        allow_nil: true
end
