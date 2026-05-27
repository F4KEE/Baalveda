import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {

  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {

    const {
      patientName,
      phone,
      doctor,
      appointmentDate,
      appointmentTime,
    } = await req.json();

    const accessToken = "EAASBc7ZCAUGMBRmpw9by9H1fGZCfY4KcHUjm0vFcKrZCqOZClFFiYMp8HX8iUTrWVUAb6FzCmL6lQ08A1fFw0FqTAg3cDV0G9nV3e2SQ8wFKtkIj7FhdlZAe534sx7wSdbTY8fzdr4CRzGsuVVjw1uq5lXcZB31sBQgKS3BastatDUZBZA1v0FfiJXZB7lG8LzrRuyFio7TG2fWzaSQZCqwDWg0YrWdaLnCq8ZB0Ay3Q8BrGt9z7yBoXhuwF7dSJrZBOWKDNKgTNZAN0L2UveQVLYKlTVTVYXZAZCcZALDL2U4cZD";

    const phoneNumberId = "1207835259070156";

    const recipientPhone = "918888423244";

    const message = `
New Appointment Booking

Patient: ${patientName}
Phone: ${phone}
Doctor: ${doctor}
Date: ${appointmentDate}
Time: ${appointmentTime}
    `;

    const response = await fetch(
      `https://graph.facebook.com/v22.0/${phoneNumberId}/messages`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          messaging_product: "whatsapp",
          to: recipientPhone,
          type: "text",
          text: {
            body: message,
          },
        }),
      }
    );

    const data = await response.json();
    console.log(data);
    return new Response(JSON.stringify(data), {
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json",
      },
      status: 200,
    });

  } catch (error) {

    return new Response(
      JSON.stringify({
        error: error.message,
      }),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
        status: 500,
      }
    );

  }
});