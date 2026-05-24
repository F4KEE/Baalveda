// Baalveda site-wide FAQ chatbot
(function () {
    const QUICK_REPLIES = [
        'Book appointment',
        'Clinic hours',
        'Location',
        'Services',
        'Contact number'
    ];

    const FAQ = [
        {
            keys: ['hello', 'hi', 'hey', 'namaste', 'good morning', 'good evening'],
            reply: 'Hello! Welcome to Baalveda Healthcare. How can I help you today? You can ask about appointments, services, hours, or our location.'
        },
        {
            keys: ['appointment', 'book', 'booking', 'schedule', 'visit'],
            reply: 'You can book an appointment online on our <a href="appointments.html">Appointments page</a>, or call us at <strong>+91 9405955751</strong> / <strong>8983099089</strong>.'
        },
        {
            keys: ['hour', 'time', 'open', 'close', 'timing', 'when'],
            reply: 'We are open <strong>Monday to Saturday, 10 AM – 6 PM</strong>. We are closed on Sundays.'
        },
        {
            keys: ['location', 'address', 'where', 'direction', 'map', 'reach'],
            reply: 'Visit us at <strong>Shop 107, Pawar Plaza, Tathawade, Datwadi</strong>. See full details on our <a href="contact.html">Contact page</a>.'
        },
        {
            keys: ['phone', 'call', 'contact', 'number', 'mobile', 'whatsapp'],
            reply: 'Call us at <strong>+91 9405955751</strong> or <strong>8983099089</strong>. You can also use our <a href="contact.html">Contact page</a>.'
        },
        {
            keys: ['service', 'treatment', 'therapy', 'vaccination', 'immunization', 'suvarn', 'ayurved', 'pediatric', 'child'],
            reply: 'We offer pediatric & neonatology care, child health consultations, vaccination & immunization, Suvarn Prashan, and Ayurvedic therapies. Learn more on our <a href="services.html">Services page</a>.'
        },
        {
            keys: ['doctor', 'about', 'who', 'team', 'pediatrician'],
            reply: 'Meet our doctors and learn about our approach on the <a href="about.html">About page</a>.'
        },
        {
            keys: ['review', 'testimonial', 'feedback', 'rating'],
            reply: 'Read what parents say about us on our <a href="reviews.html">Reviews page</a>.'
        },
        {
            keys: ['how', 'work', 'process', 'policy', 'antibiotic'],
            reply: 'We combine modern pediatrics with Ayurvedic care, including an antibiotic-free approach where appropriate. Details are on <a href="how_we_work.html">How We Work</a>.'
        },
        {
            keys: ['emergency', 'urgent', 'critical', 'ambulance'],
            reply: 'For medical emergencies, please call emergency services or visit the nearest hospital immediately. For non-urgent questions, call us during clinic hours.'
        },
        {
            keys: ['price', 'cost', 'fee', 'charge', 'payment'],
            reply: 'Fees depend on the consultation or therapy. Please call <strong>+91 9405955751</strong> for current pricing.'
        },
        {
            keys: ['thank', 'thanks', 'bye', 'goodbye'],
            reply: 'You\'re welcome! Take care of your little one. Feel free to chat again anytime.'
        }
    ];

    const DEFAULT_REPLY =
        'I\'m not sure about that. Try asking about <strong>appointments</strong>, <strong>hours</strong>, <strong>location</strong>, <strong>services</strong>, or <strong>contact</strong>. You can also call <strong>+91 9405955751</strong>.';

    function getReply(text) {
        const normalized = text.toLowerCase().trim();
        if (!normalized) return null;

        for (const item of FAQ) {
            if (item.keys.some((key) => normalized.includes(key))) {
                return item.reply;
            }
        }
        return DEFAULT_REPLY;
    }

    function createWidget() {
        const widget = document.createElement('div');
        widget.className = 'chat-widget';
        widget.setAttribute('aria-live', 'polite');
        widget.innerHTML = `
            <button type="button" class="chat-bubble" id="chatBubble" aria-label="Open chat assistant">
                <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H5.2L4 17.2V4h16v12z"/></svg>
            </button>
            <div class="chat-panel" id="chatPanel" role="dialog" aria-label="Baalveda chat assistant">
                <div class="chat-header">
                    <div class="chat-header-info">
                        <h3>Baalveda Assistant</h3>
                        <p>Ask about appointments & care</p>
                    </div>
                    <button type="button" class="chat-close" id="chatClose" aria-label="Close chat">&times;</button>
                </div>
                <div class="chat-messages" id="chatMessages"></div>
                <div class="chat-quick-replies" id="chatQuickReplies"></div>
                <form class="chat-input-area" id="chatForm">
                    <input type="text" class="chat-input" id="chatInput" placeholder="Type your question..." autocomplete="off" maxlength="500" aria-label="Your message">
                    <button type="submit" class="chat-send" aria-label="Send message">
                        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
                    </button>
                </form>
            </div>
        `;
        document.body.appendChild(widget);
        return widget;
    }

    function initChatbot() {
        if (document.getElementById('chatBubble')) return;

        createWidget();

        const bubble = document.getElementById('chatBubble');
        const panel = document.getElementById('chatPanel');
        const closeBtn = document.getElementById('chatClose');
        const messagesEl = document.getElementById('chatMessages');
        const quickRepliesEl = document.getElementById('chatQuickReplies');
        const form = document.getElementById('chatForm');
        const input = document.getElementById('chatInput');

        let hasWelcomed = false;

        function renderQuickReplies() {
            quickRepliesEl.innerHTML = '';
            QUICK_REPLIES.forEach((label) => {
                const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'chat-quick-btn';
                btn.textContent = label;
                btn.addEventListener('click', () => sendMessage(label));
                quickRepliesEl.appendChild(btn);
            });
        }

        function appendMessage(text, role) {
            const msg = document.createElement('div');
            msg.className = 'chat-message ' + role;
            msg.innerHTML = text;
            messagesEl.appendChild(msg);
            messagesEl.scrollTop = messagesEl.scrollHeight;
        }

        function sendMessage(text) {
            const trimmed = text.trim();
            if (!trimmed) return;

            appendMessage(trimmed, 'user');
            input.value = '';

            setTimeout(() => {
                const reply = getReply(trimmed);
                if (reply) appendMessage(reply, 'bot');
            }, 350);
        }

        function openChat() {
            panel.classList.add('is-open');
            bubble.hidden = true;

            if (!hasWelcomed) {
                hasWelcomed = true;
                appendMessage(
                    'Hi! I\'m the Baalveda assistant. Ask me about appointments, clinic hours, location, or our pediatric & Ayurvedic services.',
                    'bot'
                );
            }

            renderQuickReplies();
            input.focus();
        }

        function closeChat() {
            panel.classList.remove('is-open');
            bubble.hidden = false;
        }

        bubble.addEventListener('click', openChat);
        closeBtn.addEventListener('click', closeChat);

        form.addEventListener('submit', (e) => {
            e.preventDefault();
            sendMessage(input.value);
        });

        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && panel.classList.contains('is-open')) {
                closeChat();
            }
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initChatbot);
    } else {
        initChatbot();
    }
})();
