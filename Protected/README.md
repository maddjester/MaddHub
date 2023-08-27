- name: Send Discord Message
  uses: ehsanfox/discord.js-webhook
  with:
    # Important/Required Data
    id: ${{ secrets.webhook_id }}
    token: ${{ secrets.webhook_token }}

    # Optional Data
    content: Hi, this is a text for the content
    
    # Add more options if u want...
