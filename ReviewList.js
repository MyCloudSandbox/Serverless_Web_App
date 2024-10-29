import React from 'react';

function ReviewList({ reviews, onEdit, onDelete }) {
  return (
    <div>
      {reviews.map((review) => (
        <div key={review.reviewId}>
          <h2>{review.bookTitle}</h2>
          <p>{review.author}</p>
          <p>{review.reviewText}</p>
          <p>{review.rating}</p>
          <button onClick={() => onEdit(review)}>Edit</button>
          <button onClick={() => onDelete(review.reviewId)}>Delete</button>
        </div>
      ))}
    </div>
  );
}

export default ReviewList;