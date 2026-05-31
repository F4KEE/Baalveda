import { serve } from "https://deno.land/std@0.192.0/http/server.ts"
import { GoogleAuth } from "npm:google-auth-library@9.11.0"

const TARGET_DEVICE_TOKEN = "e3hyVdkqTaGbBApOlGT2a3:APA91bE9kAsNYxJClV-3Ilp0d9xFwpoxR3F_B9oBEchDt5BTiGaTn1w8RmehRuV7NX2wBjjhr81KckdXeMN03EAisTmr9akPWakMRaJP6hgj1DxfEMwBCdc"

interface WebhookPayload {
  type: 'INSERT' | 'UPDATE' | 'DELETE'
  table: string
  record: {
    id: string
    patient_name?: string
    doctor?: string
    appointment_time?: string
    appointment_date?: string
    [key: string]: any
  }
  old_record: any
}

// Generates short-lived access token explicitly via Google Service Account variables
async function getFcmAccessToken(clientEmail: string, privateKey: string): Promise<string> {
  const cleanKey = privateKey.replace(/\\n/g, '\n');
  
  const auth = new GoogleAuth({
    credentials: {
      client_email: clientEmail,
      private_key: cleanKey,
    },
    scopes: "https://www.googleapis.com/auth/firebase.messaging",
  });
  
  const client = await auth.getClient();
  const tokenResponse = await client.getAccessToken();
  
  if (!tokenResponse.token) {
    throw new Error("Failed to extract token string from Google Authentication payload.");
  }
  
  return tokenResponse.token;
}

serve(async (req) => {
  // Simple check for database trigger validation hook ping queries
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: { "Access-Control-Allow-Origin": "*" } })
  }
LETS IT BE I
  try {
    // 1. Gather Vault Secrets Configurations securely
    const firebaseProjectId = Deno.env.get("FIREBASE_PROJECT_ID");
    const firebaseClientEmail = Deno.env.get("FIREBASE_CLIENT_EMAIL");
    const firebasePrivateKey = Deno.env.get("FIREBASE_PRIVATE_KEY");

    if (!firebaseProjectId || !firebaseClientEmail || !firebasePrivateKey) {
      return new Response(
        JSON.stringify({ error: "Missing required Firebase infrastructure credentials in Supabase Vault Vault environments." }),
        { status: 500, headers: { "Content-Type": "application/json" } }
      );
    }

    // 2. Parse Incoming Database Table Webhook Event Row Data Payload
    const payload: WebhookPayload = await req.json();
    
    // Safety processing validation gate
    if (payload.type !== "INSERT") {
      return new Response(
        JSON.stringify({ message: `Skipping tracking lifecycle context logic. Event action variant target is: ${payload.type}` }),
        { status: 200, headers: { "Content-Type": "application/json" } }
      );
    }

    const patientName = payload.record.patient_name || "Unknown Patient";

    // 3. Request Authorized OAuth Access Bearer string
    const accessToken = await getFcmAccessToken(firebaseClientEmail, firebasePrivateKey);

    // 4. Construct HTTP v1 Compliant Request Message Pack Structured Layout
    const fcmEndpoint = `https://fcm.googleapis.com/v1/projects/${firebaseProjectId}/messages:send`;
    
    const messageBody = {
      message: {
        token: TARGET_DEVICE_TOKEN,
        notification: {
          title: "New Appointment",
          body: `New appointment booked by ${patientName}`,
        },
        data: {
          appointmentId: String(payload.record.id || ''),
          click_action: "FLUTTER_NOTIFICATION_CLICK"
        }
      }
    };

    // 5. Fire Dispatch Request Payload to Endpoint
    const fcmResponse = await fetch(fcmEndpoint, {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(messageBody),
    });

    const responseData = await fcmResponse.json();

    if (!fcmResponse.ok) {
      return new Response(
        JSON.stringify({ error: "FCM Engine upstream boundary error context trace logged.", details: responseData }),
        { status: fcmResponse.status, headers: { "Content-Type": "application/json" } }
      );
    }

    return new Response(
      JSON.stringify({ success: true, messageId: responseData.name }),
      { status: 200, headers: { "Content-Type": "application/json" } }
    );

  } catch (error: any) {
    return new Response(
      JSON.stringify({ error: "Internal Processing Exception Trace Logged", message: error.message }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
})