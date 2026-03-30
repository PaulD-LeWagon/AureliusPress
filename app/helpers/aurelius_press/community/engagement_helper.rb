module AureliusPress::Community::EngagementHelper
  def user_like_state(likeable, user)
    return "no_reaction" unless user
    likeable.likes.find_by(user: user)&.state || "no_reaction"
  end

  def user_reaction_emoji(reactable, user)
    return "no_reaction" unless user
    reactable.reactions.find_by(user: user)&.emoji || "no_reaction"
  end

  def engagement_emoji_map
    {
      thumbs_up: "👍",
      heart: "❤️",
      rolling_on_the_floor_laughing: "🤣",
      clapping_hands: "👏",
      thinking_face: "🤔",
      shocked_face: "😲",
      sad_face: "😢",
      angry_face: "😡",
      fire: "🔥",
      eyes: "👀",
      party_popper: "🎉",
      raised_hands: "🙌",
      star_struck: "🤩"
    }
  end

  def render_engagement_emoji(emoji_key)
    engagement_emoji_map[emoji_key.to_sym] || ""
  end
end
