from flask import Flask, jsonify, request
import openai

app = Flask('chat_app')

# กำหนดค่า OpenAI API key
openai.api_key = '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'  # เปลี่ยนเป็น OpenAI API key ของคุณ

@app.route('/chat', methods=['POST'])
def chat():
    data = request.get_json()
    message = data['message']

    # ส่งคำขอสนทนาไปยัง GPT-3.5
    response = openai.Completion.create(
        engine='text-davinci-003',  # เลือก engine ที่เหมาะสม
        prompt=message,
        max_tokens=50,  # กำหนดจำนวน token สูงสุดที่จะสร้างขึ้น
        temperature=0.7,  # กำหนดความสุ่มในการสร้างข้อความ (ค่าเริ่มต้นคือ 0.7)
        n=1  # กำหนดจำนวนคำตอบที่จะรับกลับมา (ค่าเริ่มต้นคือ 1)
    )

    reply = response.choices[0].text.strip()

    return jsonify({'reply': reply})

if __name__ == '__main__':
    app.run(debug=True, port=5000)
